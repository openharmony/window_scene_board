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
import { FormStackViewFoldController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewFoldController';

export function FormStackViewFoldControllerTest() {
  describe('FormStackViewFoldControllerTest', () => {
    it('FormStackViewFoldController_001', 0, () => {
      expect(FormStackViewFoldController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewFoldController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewFoldController_002', 0, () => {
      expect(FormStackViewFoldController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewFoldController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewFoldController_003', 0, () => {
      expect(FormStackViewFoldController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewFoldController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewFoldController_004', 0, () => {
      expect(FormStackViewFoldController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewFoldController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewFoldController_005', 0, () => {
      expect(FormStackViewFoldController.isNumber("")).assertFalse();
      expect(FormStackViewFoldController.isNumber(null)).assertFalse();
      expect(FormStackViewFoldController.isNumber(undefined)).assertFalse();
      expect(FormStackViewFoldController.isNumber("abc")).assertFalse();
      expect(FormStackViewFoldController.isNumber("123")).assertTrue();
    });

    it('FormStackViewFoldController_006', 0, () => {
      expect(FormStackViewFoldController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewFoldController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewFoldController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewFoldController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewFoldController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewFoldController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewFoldController_007', 0, () => {
      expect(FormStackViewFoldController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewFoldController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewFoldController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewFoldController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewFoldController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewFoldController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewFoldController_008', 0, () => {
      expect(FormStackViewFoldController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewFoldController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewFoldController_009', 0, () => {
      expect(FormStackViewFoldController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewFoldController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewFoldController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewFoldController_010', 0, () => {
      expect(FormStackViewFoldController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewFoldController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewFoldController_011', 0, () => {
      expect(FormStackViewFoldController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewFoldController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewFoldController_012', 0, () => {
      expect(FormStackViewFoldController.checkArr([]) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(null) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewFoldController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewFoldController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewFoldController_013', 0, () => {
      expect(FormStackViewFoldController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewFoldController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewFoldController_014', 0, () => {
      expect(FormStackViewFoldController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewFoldController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewFoldController_015', 0, () => {
      expect(FormStackViewFoldController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewFoldController_016', 0, () => {
      expect(FormStackViewFoldController.isEmpty(null)).assertTrue();
      expect(FormStackViewFoldController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewFoldController.isEmpty('')).assertTrue();
      expect(FormStackViewFoldController.isEmpty(0)).assertTrue();
      expect(FormStackViewFoldController.isEmpty([])).assertTrue();
      expect(FormStackViewFoldController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewFoldController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewFoldController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewFoldController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewFoldController_017', 0, () => {
      expect(FormStackViewFoldController.equals(null, 'a')).assertFalse();
      expect(FormStackViewFoldController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewFoldController.equals('a', null)).assertFalse();
      expect(FormStackViewFoldController.equals('a', undefined)).assertFalse();
      expect(FormStackViewFoldController.equals('a', 1)).assertFalse();
      expect(FormStackViewFoldController.equals(1, 'a')).assertFalse();
      expect(FormStackViewFoldController.equals(1, [])).assertFalse();
      expect(FormStackViewFoldController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewFoldController.equals([], m)).assertFalse();
      expect(FormStackViewFoldController.equals(m, [])).assertFalse();
      expect(FormStackViewFoldController.equals([1,2], [])).assertFalse();
      expect(FormStackViewFoldController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewFoldController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewFoldController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewFoldController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewFoldController.equals(2, 2)).assertTrue();
    })
  });
}