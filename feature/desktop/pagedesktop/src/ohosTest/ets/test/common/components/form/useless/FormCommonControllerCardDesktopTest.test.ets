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
import { FormCommonControllerCardDesktop } from '../../../../../../../main/ets/default/common/components/form/useless/FormCommonControllerCardDesktop';

export function FormCommonControllerCardDesktopTest() {
  describe('FormCommonControllerCardDesktopTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormCommonControllerCardDesktop.getSum("", '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum(null, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum('1', '') === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum('1', null) === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormCommonControllerCardDesktop.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormCommonControllerCardDesktop_002', 0, () => {
      expect(FormCommonControllerCardDesktop.stringToArray("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormCommonControllerCardDesktop_003', 0, () => {
      expect(FormCommonControllerCardDesktop.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormCommonControllerCardDesktop.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormCommonControllerCardDesktop_004', 0, () => {
      expect(FormCommonControllerCardDesktop.getIntValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormCommonControllerCardDesktop_005', 0, () => {
      expect(FormCommonControllerCardDesktop.isNumber("")).assertFalse();
      expect(FormCommonControllerCardDesktop.isNumber(null)).assertFalse();
      expect(FormCommonControllerCardDesktop.isNumber(undefined)).assertFalse();
      expect(FormCommonControllerCardDesktop.isNumber("abc")).assertFalse();
      expect(FormCommonControllerCardDesktop.isNumber("123")).assertTrue();
    });

    it('FormCommonControllerCardDesktop_006', 0, () => {
      expect(FormCommonControllerCardDesktop.getStrByCount(null , 1) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getStrByCount('' , 1) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormCommonControllerCardDesktop.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormCommonControllerCardDesktop_007', 0, () => {
      expect(FormCommonControllerCardDesktop.getDefaultId(null) === null).assertTrue();
      expect(FormCommonControllerCardDesktop.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormCommonControllerCardDesktop.getDefaultId('') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getDefaultId('default') !== '').assertTrue();
      expect(FormCommonControllerCardDesktop.getDefaultId('aaa') !== '').assertTrue();
      expect(FormCommonControllerCardDesktop.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormCommonControllerCardDesktop_008', 0, () => {
      expect(FormCommonControllerCardDesktop.getIndexByString("", []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormCommonControllerCardDesktop_009', 0, () => {
      expect(FormCommonControllerCardDesktop.drawFontWidth() === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(100) === 1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(200) === 2).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(300) === 3).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(400) === 4).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(500) === 6).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(600) === 7).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(700) === 8).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(800) === 9).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(900) === 1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWidth(1000) === 5).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat() === 3).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormCommonControllerCardDesktop.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormCommonControllerCardDesktop_010', 0, () => {
      expect(FormCommonControllerCardDesktop.drawTextAlign() === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(100) === 0).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(200) === 1).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(300) === 2).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(400) === 3).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(500) === 4).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(600) === 5).assertTrue();
      expect(FormCommonControllerCardDesktop.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormCommonControllerCardDesktop_011', 0, () => {
      expect(FormCommonControllerCardDesktop.getStringIndex('', '') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex(null, '') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('a', '') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('a', null) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormCommonControllerCardDesktop_012', 0, () => {
      expect(FormCommonControllerCardDesktop.checkArr([]) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(null) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(undefined) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr([null, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', '']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', null]) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormCommonControllerCardDesktop.getUUID().length > 0).assertTrue();
    })

    it('FormCommonControllerCardDesktop_013', 0, () => {
      expect(FormCommonControllerCardDesktop.verifyValue(1, 2) === 1).assertTrue();
      expect(FormCommonControllerCardDesktop.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormCommonControllerCardDesktop_014', 0, () => {
      expect(FormCommonControllerCardDesktop.getBinaryData(null, '') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(2, null) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(-2, '') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(0, '') === '').assertTrue();
      expect(FormCommonControllerCardDesktop.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormCommonControllerCardDesktop_015', 0, () => {
      expect(FormCommonControllerCardDesktop.getArraySum(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([], null) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([], undefined) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardDesktop.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormCommonControllerCardDesktop_016', 0, () => {
      expect(FormCommonControllerCardDesktop.isEmpty(null)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(undefined)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty('')).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(0)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty([])).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(1, null)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(1, undefined)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(1, true)).assertTrue();
      expect(FormCommonControllerCardDesktop.isEmpty(1, false)).assertFalse();
    })

    it('FormCommonControllerCardDesktop_017', 0, () => {
      expect(FormCommonControllerCardDesktop.equals(null, 'a')).assertFalse();
      expect(FormCommonControllerCardDesktop.equals(undefined, 'a')).assertFalse();
      expect(FormCommonControllerCardDesktop.equals('a', null)).assertFalse();
      expect(FormCommonControllerCardDesktop.equals('a', undefined)).assertFalse();
      expect(FormCommonControllerCardDesktop.equals('a', 1)).assertFalse();
      expect(FormCommonControllerCardDesktop.equals(1, 'a')).assertFalse();
      expect(FormCommonControllerCardDesktop.equals(1, [])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormCommonControllerCardDesktop.equals([], m)).assertFalse();
      expect(FormCommonControllerCardDesktop.equals(m, [])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([1,2], [])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([], [1, 2])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([1], [1, 2])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([1, 3], [1, 2])).assertFalse();
      expect(FormCommonControllerCardDesktop.equals([1, 2], [1, 2])).assertTrue();
      expect(FormCommonControllerCardDesktop.equals(2, 2)).assertTrue();
    })
  });
}