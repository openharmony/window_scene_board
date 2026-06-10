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
import { FormStackDbManagerPad } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbManagerPad';

export function FormStackDbManagerPadTest() {
  describe('FormStackDbManagerPadTest', () => {
    it('FormStackDbManagerPad_001', 0, () => {
      expect(FormStackDbManagerPad.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbManagerPad.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbManagerPad_002', 0, () => {
      expect(FormStackDbManagerPad.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPad.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbManagerPad_003', 0, () => {
      expect(FormStackDbManagerPad.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbManagerPad.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbManagerPad_004', 0, () => {
      expect(FormStackDbManagerPad.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPad.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbManagerPad_005', 0, () => {
      expect(FormStackDbManagerPad.isNumber("")).assertFalse();
      expect(FormStackDbManagerPad.isNumber(null)).assertFalse();
      expect(FormStackDbManagerPad.isNumber(undefined)).assertFalse();
      expect(FormStackDbManagerPad.isNumber("abc")).assertFalse();
      expect(FormStackDbManagerPad.isNumber("123")).assertTrue();
    });

    it('FormStackDbManagerPad_006', 0, () => {
      expect(FormStackDbManagerPad.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbManagerPad.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbManagerPad.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbManagerPad.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbManagerPad.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbManagerPad.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbManagerPad_007', 0, () => {
      expect(FormStackDbManagerPad.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbManagerPad.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbManagerPad.getDefaultId('') === '').assertTrue();
      expect(FormStackDbManagerPad.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbManagerPad.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbManagerPad.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbManagerPad_008', 0, () => {
      expect(FormStackDbManagerPad.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbManagerPad_009', 0, () => {
      expect(FormStackDbManagerPad.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbManagerPad.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbManagerPad.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbManagerPad_010', 0, () => {
      expect(FormStackDbManagerPad.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbManagerPad.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbManagerPad_011', 0, () => {
      expect(FormStackDbManagerPad.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbManagerPad.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbManagerPad_012', 0, () => {
      expect(FormStackDbManagerPad.checkArr([]) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(null) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbManagerPad.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbManagerPad.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbManagerPad_013', 0, () => {
      expect(FormStackDbManagerPad.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbManagerPad.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbManagerPad_014', 0, () => {
      expect(FormStackDbManagerPad.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbManagerPad.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbManagerPad_015', 0, () => {
      expect(FormStackDbManagerPad.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPad.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbManagerPad_016', 0, () => {
      expect(FormStackDbManagerPad.isEmpty(null)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(undefined)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty('')).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(0)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty([])).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(1, null)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(1, true)).assertTrue();
      expect(FormStackDbManagerPad.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbManagerPad_017', 0, () => {
      expect(FormStackDbManagerPad.equals(null, 'a')).assertFalse();
      expect(FormStackDbManagerPad.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbManagerPad.equals('a', null)).assertFalse();
      expect(FormStackDbManagerPad.equals('a', undefined)).assertFalse();
      expect(FormStackDbManagerPad.equals('a', 1)).assertFalse();
      expect(FormStackDbManagerPad.equals(1, 'a')).assertFalse();
      expect(FormStackDbManagerPad.equals(1, [])).assertFalse();
      expect(FormStackDbManagerPad.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbManagerPad.equals([], m)).assertFalse();
      expect(FormStackDbManagerPad.equals(m, [])).assertFalse();
      expect(FormStackDbManagerPad.equals([1,2], [])).assertFalse();
      expect(FormStackDbManagerPad.equals([], [1, 2])).assertFalse();
      expect(FormStackDbManagerPad.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbManagerPad.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbManagerPad.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbManagerPad.equals(2, 2)).assertTrue();
    })
  });
}