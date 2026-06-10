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
import { FormStackAddController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAddController';

export function FormStackAddControllerTest() {
  describe('FormStackAddControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackAddController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAddController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAddController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAddController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAddController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAddController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAddController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAddController_002', 0, () => {
      expect(FormStackAddController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAddController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAddController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAddController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAddController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAddController_003', 0, () => {
      expect(FormStackAddController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAddController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAddController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAddController_004', 0, () => {
      expect(FormStackAddController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAddController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAddController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAddController_005', 0, () => {
      expect(FormStackAddController.isNumber("")).assertFalse();
      expect(FormStackAddController.isNumber(null)).assertFalse();
      expect(FormStackAddController.isNumber(undefined)).assertFalse();
      expect(FormStackAddController.isNumber("abc")).assertFalse();
      expect(FormStackAddController.isNumber("123")).assertTrue();
    });

    it('FormStackAddController_006', 0, () => {
      expect(FormStackAddController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAddController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAddController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAddController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAddController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAddController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAddController_007', 0, () => {
      expect(FormStackAddController.getDefaultId(null) === null).assertTrue();
      expect(FormStackAddController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAddController.getDefaultId('') === '').assertTrue();
      expect(FormStackAddController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAddController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAddController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAddController_008', 0, () => {
      expect(FormStackAddController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAddController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAddController_009', 0, () => {
      expect(FormStackAddController.drawFontWidth() === -1).assertTrue();
      expect(FormStackAddController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAddController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAddController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAddController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAddController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAddController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAddController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAddController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAddController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAddController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAddController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAddController_010', 0, () => {
      expect(FormStackAddController.drawTextAlign() === -1).assertTrue();
      expect(FormStackAddController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAddController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAddController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAddController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAddController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAddController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAddController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAddController_011', 0, () => {
      expect(FormStackAddController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAddController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAddController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAddController_012', 0, () => {
      expect(FormStackAddController.checkArr([]) === false).assertTrue();
      expect(FormStackAddController.checkArr(null) === false).assertTrue();
      expect(FormStackAddController.checkArr(undefined) === false).assertTrue();
      expect(FormStackAddController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAddController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAddController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAddController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAddController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAddController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAddController.getUUID().length > 0).assertTrue();
    })

    it('FormStackAddController_013', 0, () => {
      expect(FormStackAddController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAddController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAddController_014', 0, () => {
      expect(FormStackAddController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAddController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAddController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAddController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAddController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAddController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAddController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAddController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAddController_015', 0, () => {
      expect(FormStackAddController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAddController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAddController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAddController_016', 0, () => {
      expect(FormStackAddController.isEmpty(null)).assertTrue();
      expect(FormStackAddController.isEmpty(undefined)).assertTrue();
      expect(FormStackAddController.isEmpty('')).assertTrue();
      expect(FormStackAddController.isEmpty(0)).assertTrue();
      expect(FormStackAddController.isEmpty([])).assertTrue();
      expect(FormStackAddController.isEmpty(1, null)).assertTrue();
      expect(FormStackAddController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAddController.isEmpty(1, true)).assertTrue();
      expect(FormStackAddController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAddController_017', 0, () => {
      expect(FormStackAddController.equals(null, 'a')).assertFalse();
      expect(FormStackAddController.equals(undefined, 'a')).assertFalse();
      expect(FormStackAddController.equals('a', null)).assertFalse();
      expect(FormStackAddController.equals('a', undefined)).assertFalse();
      expect(FormStackAddController.equals('a', 1)).assertFalse();
      expect(FormStackAddController.equals(1, 'a')).assertFalse();
      expect(FormStackAddController.equals(1, [])).assertFalse();
      expect(FormStackAddController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAddController.equals([], m)).assertFalse();
      expect(FormStackAddController.equals(m, [])).assertFalse();
      expect(FormStackAddController.equals([1,2], [])).assertFalse();
      expect(FormStackAddController.equals([], [1, 2])).assertFalse();
      expect(FormStackAddController.equals([1], [1, 2])).assertFalse();
      expect(FormStackAddController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAddController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAddController.equals(2, 2)).assertTrue();
    })
  });
}