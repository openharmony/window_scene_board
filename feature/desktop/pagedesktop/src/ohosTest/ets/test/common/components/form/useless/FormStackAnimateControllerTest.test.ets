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
import { FormStackViewAnimateController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAnimateController';

export function FormStackViewAnimateControllerTest() {
  describe('FormStackViewAnimateControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAnimateController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAnimateController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAnimateController_002', 0, () => {
      expect(FormStackViewAnimateController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAnimateController_003', 0, () => {
      expect(FormStackViewAnimateController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAnimateController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAnimateController_004', 0, () => {
      expect(FormStackViewAnimateController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAnimateController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAnimateController_005', 0, () => {
      expect(FormStackViewAnimateController.isNumber("")).assertFalse();
      expect(FormStackViewAnimateController.isNumber(null)).assertFalse();
      expect(FormStackViewAnimateController.isNumber(undefined)).assertFalse();
      expect(FormStackViewAnimateController.isNumber("abc")).assertFalse();
      expect(FormStackViewAnimateController.isNumber("123")).assertTrue();
    });

    it('FormStackViewAnimateController_006', 0, () => {
      expect(FormStackViewAnimateController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAnimateController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAnimateController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAnimateController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAnimateController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAnimateController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAnimateController_007', 0, () => {
      expect(FormStackViewAnimateController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAnimateController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAnimateController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAnimateController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAnimateController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAnimateController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAnimateController_008', 0, () => {
      expect(FormStackViewAnimateController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAnimateController_009', 0, () => {
      expect(FormStackViewAnimateController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAnimateController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAnimateController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAnimateController_010', 0, () => {
      expect(FormStackViewAnimateController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAnimateController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAnimateController_011', 0, () => {
      expect(FormStackViewAnimateController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAnimateController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAnimateController_012', 0, () => {
      expect(FormStackViewAnimateController.checkArr([]) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(null) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAnimateController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAnimateController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAnimateController_013', 0, () => {
      expect(FormStackViewAnimateController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAnimateController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAnimateController_014', 0, () => {
      expect(FormStackViewAnimateController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAnimateController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAnimateController_015', 0, () => {
      expect(FormStackViewAnimateController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAnimateController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAnimateController_016', 0, () => {
      expect(FormStackViewAnimateController.isEmpty(null)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty('')).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(0)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty([])).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAnimateController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAnimateController_017', 0, () => {
      expect(FormStackViewAnimateController.equals(null, 'a')).assertFalse();
      expect(FormStackViewAnimateController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAnimateController.equals('a', null)).assertFalse();
      expect(FormStackViewAnimateController.equals('a', undefined)).assertFalse();
      expect(FormStackViewAnimateController.equals('a', 1)).assertFalse();
      expect(FormStackViewAnimateController.equals(1, 'a')).assertFalse();
      expect(FormStackViewAnimateController.equals(1, [])).assertFalse();
      expect(FormStackViewAnimateController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAnimateController.equals([], m)).assertFalse();
      expect(FormStackViewAnimateController.equals(m, [])).assertFalse();
      expect(FormStackViewAnimateController.equals([1,2], [])).assertFalse();
      expect(FormStackViewAnimateController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAnimateController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAnimateController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAnimateController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAnimateController.equals(2, 2)).assertTrue();
    })
  });
}