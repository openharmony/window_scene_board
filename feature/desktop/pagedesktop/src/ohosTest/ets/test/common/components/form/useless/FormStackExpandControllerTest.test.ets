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
import { FormStackExpandController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackExpandController';

export function FormStackExpandControllerTest() {
  describe('FormStackExpandControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackExpandController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackExpandController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackExpandController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackExpandController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackExpandController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackExpandController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackExpandController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackExpandController_002', 0, () => {
      expect(FormStackExpandController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackExpandController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackExpandController_003', 0, () => {
      expect(FormStackExpandController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackExpandController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackExpandController_004', 0, () => {
      expect(FormStackExpandController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackExpandController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackExpandController_005', 0, () => {
      expect(FormStackExpandController.isNumber("")).assertFalse();
      expect(FormStackExpandController.isNumber(null)).assertFalse();
      expect(FormStackExpandController.isNumber(undefined)).assertFalse();
      expect(FormStackExpandController.isNumber("abc")).assertFalse();
      expect(FormStackExpandController.isNumber("123")).assertTrue();
    });

    it('FormStackExpandController_006', 0, () => {
      expect(FormStackExpandController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackExpandController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackExpandController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackExpandController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackExpandController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackExpandController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackExpandController_007', 0, () => {
      expect(FormStackExpandController.getDefaultId(null) === null).assertTrue();
      expect(FormStackExpandController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackExpandController.getDefaultId('') === '').assertTrue();
      expect(FormStackExpandController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackExpandController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackExpandController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackExpandController_008', 0, () => {
      expect(FormStackExpandController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackExpandController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackExpandController_009', 0, () => {
      expect(FormStackExpandController.drawFontWidth() === -1).assertTrue();
      expect(FormStackExpandController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackExpandController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackExpandController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackExpandController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackExpandController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackExpandController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackExpandController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackExpandController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackExpandController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackExpandController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackExpandController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackExpandController_010', 0, () => {
      expect(FormStackExpandController.drawTextAlign() === -1).assertTrue();
      expect(FormStackExpandController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackExpandController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackExpandController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackExpandController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackExpandController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackExpandController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackExpandController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackExpandController_011', 0, () => {
      expect(FormStackExpandController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackExpandController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackExpandController_012', 0, () => {
      expect(FormStackExpandController.checkArr([]) === false).assertTrue();
      expect(FormStackExpandController.checkArr(null) === false).assertTrue();
      expect(FormStackExpandController.checkArr(undefined) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackExpandController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackExpandController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackExpandController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackExpandController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackExpandController.getUUID().length > 0).assertTrue();
    })

    it('FormStackExpandController_013', 0, () => {
      expect(FormStackExpandController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackExpandController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackExpandController_014', 0, () => {
      expect(FormStackExpandController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackExpandController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackExpandController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackExpandController_015', 0, () => {
      expect(FormStackExpandController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackExpandController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackExpandController_016', 0, () => {
      expect(FormStackExpandController.isEmpty(null)).assertTrue();
      expect(FormStackExpandController.isEmpty(undefined)).assertTrue();
      expect(FormStackExpandController.isEmpty('')).assertTrue();
      expect(FormStackExpandController.isEmpty(0)).assertTrue();
      expect(FormStackExpandController.isEmpty([])).assertTrue();
      expect(FormStackExpandController.isEmpty(1, null)).assertTrue();
      expect(FormStackExpandController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackExpandController.isEmpty(1, true)).assertTrue();
      expect(FormStackExpandController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackExpandController_017', 0, () => {
      expect(FormStackExpandController.equals(null, 'a')).assertFalse();
      expect(FormStackExpandController.equals(undefined, 'a')).assertFalse();
      expect(FormStackExpandController.equals('a', null)).assertFalse();
      expect(FormStackExpandController.equals('a', undefined)).assertFalse();
      expect(FormStackExpandController.equals('a', 1)).assertFalse();
      expect(FormStackExpandController.equals(1, 'a')).assertFalse();
      expect(FormStackExpandController.equals(1, [])).assertFalse();
      expect(FormStackExpandController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackExpandController.equals([], m)).assertFalse();
      expect(FormStackExpandController.equals(m, [])).assertFalse();
      expect(FormStackExpandController.equals([1,2], [])).assertFalse();
      expect(FormStackExpandController.equals([], [1, 2])).assertFalse();
      expect(FormStackExpandController.equals([1], [1, 2])).assertFalse();
      expect(FormStackExpandController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackExpandController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackExpandController.equals(2, 2)).assertTrue();
    })
  });
}