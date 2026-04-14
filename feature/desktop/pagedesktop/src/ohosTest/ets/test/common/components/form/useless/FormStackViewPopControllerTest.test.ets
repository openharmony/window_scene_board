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
import { FormStackViewPopController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPopController';

export function FormStackViewPopControllerTest() {
  describe('FormStackViewPopControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPopController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPopController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPopController_002', 0, () => {
      expect(FormStackViewPopController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPopController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPopController_003', 0, () => {
      expect(FormStackViewPopController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPopController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPopController_004', 0, () => {
      expect(FormStackViewPopController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPopController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPopController_005', 0, () => {
      expect(FormStackViewPopController.isNumber("")).assertFalse();
      expect(FormStackViewPopController.isNumber(null)).assertFalse();
      expect(FormStackViewPopController.isNumber(undefined)).assertFalse();
      expect(FormStackViewPopController.isNumber("abc")).assertFalse();
      expect(FormStackViewPopController.isNumber("123")).assertTrue();
    });

    it('FormStackViewPopController_006', 0, () => {
      expect(FormStackViewPopController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPopController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPopController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPopController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPopController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPopController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPopController_007', 0, () => {
      expect(FormStackViewPopController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPopController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPopController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPopController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPopController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPopController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPopController_008', 0, () => {
      expect(FormStackViewPopController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPopController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPopController_009', 0, () => {
      expect(FormStackViewPopController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPopController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPopController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPopController_010', 0, () => {
      expect(FormStackViewPopController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPopController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPopController_011', 0, () => {
      expect(FormStackViewPopController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPopController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPopController_012', 0, () => {
      expect(FormStackViewPopController.checkArr([]) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(null) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPopController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPopController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPopController_013', 0, () => {
      expect(FormStackViewPopController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPopController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPopController_014', 0, () => {
      expect(FormStackViewPopController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPopController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPopController_015', 0, () => {
      expect(FormStackViewPopController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPopController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPopController_016', 0, () => {
      expect(FormStackViewPopController.isEmpty(null)).assertTrue();
      expect(FormStackViewPopController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPopController.isEmpty('')).assertTrue();
      expect(FormStackViewPopController.isEmpty(0)).assertTrue();
      expect(FormStackViewPopController.isEmpty([])).assertTrue();
      expect(FormStackViewPopController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPopController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPopController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPopController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPopController_017', 0, () => {
      expect(FormStackViewPopController.equals(null, 'a')).assertFalse();
      expect(FormStackViewPopController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPopController.equals('a', null)).assertFalse();
      expect(FormStackViewPopController.equals('a', undefined)).assertFalse();
      expect(FormStackViewPopController.equals('a', 1)).assertFalse();
      expect(FormStackViewPopController.equals(1, 'a')).assertFalse();
      expect(FormStackViewPopController.equals(1, [])).assertFalse();
      expect(FormStackViewPopController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPopController.equals([], m)).assertFalse();
      expect(FormStackViewPopController.equals(m, [])).assertFalse();
      expect(FormStackViewPopController.equals([1,2], [])).assertFalse();
      expect(FormStackViewPopController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPopController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPopController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPopController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPopController.equals(2, 2)).assertTrue();
    })
  });
}