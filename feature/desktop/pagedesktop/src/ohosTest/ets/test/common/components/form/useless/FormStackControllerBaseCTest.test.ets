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
import { FormStackController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackController';

export function FormStackControllerTest() {
  describe('FormStackControllerTest', () => {
    it('FormStackController_001', 0,() => {
      expect(FormStackController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackController_002', 0, () => {
      expect(FormStackController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackController_003', 0, () => {
      expect(FormStackController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackController_004', 0, () => {
      expect(FormStackController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackController_005', 0, () => {
      expect(FormStackController.isNumber("")).assertFalse();
      expect(FormStackController.isNumber(null)).assertFalse();
      expect(FormStackController.isNumber(undefined)).assertFalse();
      expect(FormStackController.isNumber("abc")).assertFalse();
      expect(FormStackController.isNumber("123")).assertTrue();
    });

    it('FormStackController_006', 0, () => {
      expect(FormStackController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackController_007', 0, () => {
      expect(FormStackController.getDefaultId(null) === null).assertTrue();
      expect(FormStackController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackController.getDefaultId('') === '').assertTrue();
      expect(FormStackController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackController_008', 0, () => {
      expect(FormStackController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackController_009', 0, () => {
      expect(FormStackController.drawFontWidth() === -1).assertTrue();
      expect(FormStackController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackController_010', 0, () => {
      expect(FormStackController.drawTextAlign() === -1).assertTrue();
      expect(FormStackController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackController_011', 0, () => {
      expect(FormStackController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackController_012', 0, () => {
      expect(FormStackController.checkArr([]) === false).assertTrue();
      expect(FormStackController.checkArr(null) === false).assertTrue();
      expect(FormStackController.checkArr(undefined) === false).assertTrue();
      expect(FormStackController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackController.getUUID().length > 0).assertTrue();
    })

    it('FormStackController_013', 0, () => {
      expect(FormStackController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackController_014', 0, () => {
      expect(FormStackController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackController_015', 0, () => {
      expect(FormStackController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackController_016', 0, () => {
      expect(FormStackController.isEmpty(null)).assertTrue();
      expect(FormStackController.isEmpty(undefined)).assertTrue();
      expect(FormStackController.isEmpty('')).assertTrue();
      expect(FormStackController.isEmpty(0)).assertTrue();
      expect(FormStackController.isEmpty([])).assertTrue();
      expect(FormStackController.isEmpty(1, null)).assertTrue();
      expect(FormStackController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackController.isEmpty(1, true)).assertTrue();
      expect(FormStackController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackController_017', 0, () => {
      expect(FormStackController.equals(null, 'a')).assertFalse();
      expect(FormStackController.equals(undefined, 'a')).assertFalse();
      expect(FormStackController.equals('a', null)).assertFalse();
      expect(FormStackController.equals('a', undefined)).assertFalse();
      expect(FormStackController.equals('a', 1)).assertFalse();
      expect(FormStackController.equals(1, 'a')).assertFalse();
      expect(FormStackController.equals(1, [])).assertFalse();
      expect(FormStackController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackController.equals([], m)).assertFalse();
      expect(FormStackController.equals(m, [])).assertFalse();
      expect(FormStackController.equals([1,2], [])).assertFalse();
      expect(FormStackController.equals([], [1, 2])).assertFalse();
      expect(FormStackController.equals([1], [1, 2])).assertFalse();
      expect(FormStackController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackController.equals(2, 2)).assertTrue();
    })
  });
}