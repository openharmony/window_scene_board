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
import { FormStackViewPushController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPushController';

export function FormStackViewPushControllerTest() {
  describe('FormStackViewPushControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPushController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPushController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPushController_002', 0, () => {
      expect(FormStackViewPushController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPushController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPushController_003', 0, () => {
      expect(FormStackViewPushController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPushController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPushController_004', 0, () => {
      expect(FormStackViewPushController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPushController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPushController_005', 0, () => {
      expect(FormStackViewPushController.isNumber("")).assertFalse();
      expect(FormStackViewPushController.isNumber(null)).assertFalse();
      expect(FormStackViewPushController.isNumber(undefined)).assertFalse();
      expect(FormStackViewPushController.isNumber("abc")).assertFalse();
      expect(FormStackViewPushController.isNumber("123")).assertTrue();
    });

    it('FormStackViewPushController_006', 0, () => {
      expect(FormStackViewPushController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPushController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPushController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPushController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPushController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPushController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPushController_007', 0, () => {
      expect(FormStackViewPushController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPushController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPushController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPushController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPushController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPushController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPushController_008', 0, () => {
      expect(FormStackViewPushController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPushController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPushController_009', 0, () => {
      expect(FormStackViewPushController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPushController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPushController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPushController_010', 0, () => {
      expect(FormStackViewPushController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPushController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPushController_011', 0, () => {
      expect(FormStackViewPushController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPushController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPushController_012', 0, () => {
      expect(FormStackViewPushController.checkArr([]) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(null) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPushController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPushController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPushController_013', 0, () => {
      expect(FormStackViewPushController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPushController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPushController_014', 0, () => {
      expect(FormStackViewPushController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPushController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPushController_015', 0, () => {
      expect(FormStackViewPushController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPushController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPushController_016', 0, () => {
      expect(FormStackViewPushController.isEmpty(null)).assertTrue();
      expect(FormStackViewPushController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPushController.isEmpty('')).assertTrue();
      expect(FormStackViewPushController.isEmpty(0)).assertTrue();
      expect(FormStackViewPushController.isEmpty([])).assertTrue();
      expect(FormStackViewPushController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPushController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPushController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPushController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPushController_017', 0, () => {
      expect(FormStackViewPushController.equals(null, 'a')).assertFalse();
      expect(FormStackViewPushController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPushController.equals('a', null)).assertFalse();
      expect(FormStackViewPushController.equals('a', undefined)).assertFalse();
      expect(FormStackViewPushController.equals('a', 1)).assertFalse();
      expect(FormStackViewPushController.equals(1, 'a')).assertFalse();
      expect(FormStackViewPushController.equals(1, [])).assertFalse();
      expect(FormStackViewPushController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPushController.equals([], m)).assertFalse();
      expect(FormStackViewPushController.equals(m, [])).assertFalse();
      expect(FormStackViewPushController.equals([1,2], [])).assertFalse();
      expect(FormStackViewPushController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPushController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPushController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPushController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPushController.equals(2, 2)).assertTrue();
    })
  });
}