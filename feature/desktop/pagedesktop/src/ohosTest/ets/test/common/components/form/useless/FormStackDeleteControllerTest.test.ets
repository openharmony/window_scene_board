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
import { FormStackDeleteController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDeleteController';

export function FormStackDeleteControllerTest() {
  describe('FormStackDeleteControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackDeleteController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDeleteController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDeleteController_002', 0, () => {
      expect(FormStackDeleteController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDeleteController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDeleteController_003', 0, () => {
      expect(FormStackDeleteController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDeleteController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDeleteController_004', 0, () => {
      expect(FormStackDeleteController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDeleteController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDeleteController_005', 0, () => {
      expect(FormStackDeleteController.isNumber("")).assertFalse();
      expect(FormStackDeleteController.isNumber(null)).assertFalse();
      expect(FormStackDeleteController.isNumber(undefined)).assertFalse();
      expect(FormStackDeleteController.isNumber("abc")).assertFalse();
      expect(FormStackDeleteController.isNumber("123")).assertTrue();
    });

    it('FormStackDeleteController_006', 0, () => {
      expect(FormStackDeleteController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDeleteController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDeleteController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDeleteController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDeleteController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDeleteController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDeleteController_007', 0, () => {
      expect(FormStackDeleteController.getDefaultId(null) === null).assertTrue();
      expect(FormStackDeleteController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDeleteController.getDefaultId('') === '').assertTrue();
      expect(FormStackDeleteController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDeleteController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDeleteController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDeleteController_008', 0, () => {
      expect(FormStackDeleteController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDeleteController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDeleteController_009', 0, () => {
      expect(FormStackDeleteController.drawFontWidth() === -1).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDeleteController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDeleteController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDeleteController_010', 0, () => {
      expect(FormStackDeleteController.drawTextAlign() === -1).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDeleteController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDeleteController_011', 0, () => {
      expect(FormStackDeleteController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDeleteController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDeleteController_012', 0, () => {
      expect(FormStackDeleteController.checkArr([]) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(null) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(undefined) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDeleteController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDeleteController.getUUID().length > 0).assertTrue();
    })

    it('FormStackDeleteController_013', 0, () => {
      expect(FormStackDeleteController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDeleteController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDeleteController_014', 0, () => {
      expect(FormStackDeleteController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDeleteController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDeleteController_015', 0, () => {
      expect(FormStackDeleteController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDeleteController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDeleteController_016', 0, () => {
      expect(FormStackDeleteController.isEmpty(null)).assertTrue();
      expect(FormStackDeleteController.isEmpty(undefined)).assertTrue();
      expect(FormStackDeleteController.isEmpty('')).assertTrue();
      expect(FormStackDeleteController.isEmpty(0)).assertTrue();
      expect(FormStackDeleteController.isEmpty([])).assertTrue();
      expect(FormStackDeleteController.isEmpty(1, null)).assertTrue();
      expect(FormStackDeleteController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDeleteController.isEmpty(1, true)).assertTrue();
      expect(FormStackDeleteController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDeleteController_017', 0, () => {
      expect(FormStackDeleteController.equals(null, 'a')).assertFalse();
      expect(FormStackDeleteController.equals(undefined, 'a')).assertFalse();
      expect(FormStackDeleteController.equals('a', null)).assertFalse();
      expect(FormStackDeleteController.equals('a', undefined)).assertFalse();
      expect(FormStackDeleteController.equals('a', 1)).assertFalse();
      expect(FormStackDeleteController.equals(1, 'a')).assertFalse();
      expect(FormStackDeleteController.equals(1, [])).assertFalse();
      expect(FormStackDeleteController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDeleteController.equals([], m)).assertFalse();
      expect(FormStackDeleteController.equals(m, [])).assertFalse();
      expect(FormStackDeleteController.equals([1,2], [])).assertFalse();
      expect(FormStackDeleteController.equals([], [1, 2])).assertFalse();
      expect(FormStackDeleteController.equals([1], [1, 2])).assertFalse();
      expect(FormStackDeleteController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDeleteController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDeleteController.equals(2, 2)).assertTrue();
    })
  });
}