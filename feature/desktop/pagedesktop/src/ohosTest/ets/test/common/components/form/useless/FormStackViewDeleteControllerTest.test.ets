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
import { FormStackViewDeleteController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewDeleteController';

export function FormStackViewDeleteControllerTest() {
  describe('FormStackViewDeleteControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewDeleteController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewDeleteController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewDeleteController_002', 0, () => {
      expect(FormStackViewDeleteController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewDeleteController_003', 0, () => {
      expect(FormStackViewDeleteController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewDeleteController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewDeleteController_004', 0, () => {
      expect(FormStackViewDeleteController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewDeleteController_005', 0, () => {
      expect(FormStackViewDeleteController.isNumber("")).assertFalse();
      expect(FormStackViewDeleteController.isNumber(null)).assertFalse();
      expect(FormStackViewDeleteController.isNumber(undefined)).assertFalse();
      expect(FormStackViewDeleteController.isNumber("abc")).assertFalse();
      expect(FormStackViewDeleteController.isNumber("123")).assertTrue();
    });

    it('FormStackViewDeleteController_006', 0, () => {
      expect(FormStackViewDeleteController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewDeleteController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewDeleteController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewDeleteController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewDeleteController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewDeleteController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewDeleteController_007', 0, () => {
      expect(FormStackViewDeleteController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewDeleteController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewDeleteController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewDeleteController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewDeleteController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewDeleteController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewDeleteController_008', 0, () => {
      expect(FormStackViewDeleteController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewDeleteController_009', 0, () => {
      expect(FormStackViewDeleteController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewDeleteController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewDeleteController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewDeleteController_010', 0, () => {
      expect(FormStackViewDeleteController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewDeleteController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewDeleteController_011', 0, () => {
      expect(FormStackViewDeleteController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewDeleteController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewDeleteController_012', 0, () => {
      expect(FormStackViewDeleteController.checkArr([]) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(null) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewDeleteController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewDeleteController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewDeleteController_013', 0, () => {
      expect(FormStackViewDeleteController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewDeleteController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewDeleteController_014', 0, () => {
      expect(FormStackViewDeleteController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewDeleteController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewDeleteController_015', 0, () => {
      expect(FormStackViewDeleteController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewDeleteController_016', 0, () => {
      expect(FormStackViewDeleteController.isEmpty(null)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty('')).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(0)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty([])).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewDeleteController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewDeleteController_017', 0, () => {
      expect(FormStackViewDeleteController.equals(null, 'a')).assertFalse();
      expect(FormStackViewDeleteController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewDeleteController.equals('a', null)).assertFalse();
      expect(FormStackViewDeleteController.equals('a', undefined)).assertFalse();
      expect(FormStackViewDeleteController.equals('a', 1)).assertFalse();
      expect(FormStackViewDeleteController.equals(1, 'a')).assertFalse();
      expect(FormStackViewDeleteController.equals(1, [])).assertFalse();
      expect(FormStackViewDeleteController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewDeleteController.equals([], m)).assertFalse();
      expect(FormStackViewDeleteController.equals(m, [])).assertFalse();
      expect(FormStackViewDeleteController.equals([1,2], [])).assertFalse();
      expect(FormStackViewDeleteController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewDeleteController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewDeleteController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewDeleteController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewDeleteController.equals(2, 2)).assertTrue();
    })
  });
}