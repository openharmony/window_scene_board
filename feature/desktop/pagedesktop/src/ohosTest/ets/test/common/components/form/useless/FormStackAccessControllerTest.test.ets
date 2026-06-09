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
import { FormStackAccessController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAccessController';

export function FormStackAccessControllerTest() {
  describe('FormStackAccessControllerTest', () => {
    it('FormStackAccessController_001', 0, () => {
      expect(FormStackAccessController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAccessController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAccessController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAccessController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAccessController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAccessController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAccessController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAccessController_002', 0, () => {
      expect(FormStackAccessController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAccessController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAccessController_003', 0, () => {
      expect(FormStackAccessController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAccessController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAccessController_004', 0, () => {
      expect(FormStackAccessController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAccessController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAccessController_005', 0, () => {
      expect(FormStackAccessController.isNumber("")).assertFalse();
      expect(FormStackAccessController.isNumber(null)).assertFalse();
      expect(FormStackAccessController.isNumber(undefined)).assertFalse();
      expect(FormStackAccessController.isNumber("abc")).assertFalse();
      expect(FormStackAccessController.isNumber("123")).assertTrue();
    });

    it('FormStackAccessController_006', 0, () => {
      expect(FormStackAccessController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAccessController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAccessController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAccessController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAccessController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAccessController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAccessController_007', 0, () => {
      expect(FormStackAccessController.getDefaultId(null) === null).assertTrue();
      expect(FormStackAccessController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAccessController.getDefaultId('') === '').assertTrue();
      expect(FormStackAccessController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAccessController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAccessController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAccessController_008', 0, () => {
      expect(FormStackAccessController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAccessController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAccessController_009', 0, () => {
      expect(FormStackAccessController.drawFontWidth() === -1).assertTrue();
      expect(FormStackAccessController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAccessController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAccessController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAccessController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAccessController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAccessController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAccessController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAccessController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAccessController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAccessController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAccessController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAccessController_010', 0, () => {
      expect(FormStackAccessController.drawTextAlign() === -1).assertTrue();
      expect(FormStackAccessController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAccessController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAccessController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAccessController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAccessController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAccessController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAccessController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAccessController_011', 0, () => {
      expect(FormStackAccessController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAccessController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAccessController_012', 0, () => {
      expect(FormStackAccessController.checkArr([]) === false).assertTrue();
      expect(FormStackAccessController.checkArr(null) === false).assertTrue();
      expect(FormStackAccessController.checkArr(undefined) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAccessController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAccessController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAccessController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAccessController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAccessController.getUUID().length > 0).assertTrue();
    })

    it('FormStackAccessController_013', 0, () => {
      expect(FormStackAccessController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAccessController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAccessController_014', 0, () => {
      expect(FormStackAccessController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAccessController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAccessController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAccessController_015', 0, () => {
      expect(FormStackAccessController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAccessController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAccessController_016', 0, () => {
      expect(FormStackAccessController.isEmpty(null)).assertTrue();
      expect(FormStackAccessController.isEmpty(undefined)).assertTrue();
      expect(FormStackAccessController.isEmpty('')).assertTrue();
      expect(FormStackAccessController.isEmpty(0)).assertTrue();
      expect(FormStackAccessController.isEmpty([])).assertTrue();
      expect(FormStackAccessController.isEmpty(1, null)).assertTrue();
      expect(FormStackAccessController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAccessController.isEmpty(1, true)).assertTrue();
      expect(FormStackAccessController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAccessController_017', 0, () => {
      expect(FormStackAccessController.equals(null, 'a')).assertFalse();
      expect(FormStackAccessController.equals(undefined, 'a')).assertFalse();
      expect(FormStackAccessController.equals('a', null)).assertFalse();
      expect(FormStackAccessController.equals('a', undefined)).assertFalse();
      expect(FormStackAccessController.equals('a', 1)).assertFalse();
      expect(FormStackAccessController.equals(1, 'a')).assertFalse();
      expect(FormStackAccessController.equals(1, [])).assertFalse();
      expect(FormStackAccessController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAccessController.equals([], m)).assertFalse();
      expect(FormStackAccessController.equals(m, [])).assertFalse();
      expect(FormStackAccessController.equals([1,2], [])).assertFalse();
      expect(FormStackAccessController.equals([], [1, 2])).assertFalse();
      expect(FormStackAccessController.equals([1], [1, 2])).assertFalse();
      expect(FormStackAccessController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAccessController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAccessController.equals(2, 2)).assertTrue();
    })
  });
}