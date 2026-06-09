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
import { FormStackDbAdapterPad } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbAdapterPad';

export function FormStackDbAdapterPadTest() {
  describe('FormStackDbAdapterPadTest', () => {
    it('FormStackDbAdapterPad_001', 0, () => {
      expect(FormStackDbAdapterPad.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbAdapterPad.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbAdapterPad_002', 0, () => {
      expect(FormStackDbAdapterPad.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPad.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbAdapterPad_003', 0, () => {
      expect(FormStackDbAdapterPad.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbAdapterPad.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbAdapterPad_004', 0, () => {
      expect(FormStackDbAdapterPad.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPad.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbAdapterPad_005', 0, () => {
      expect(FormStackDbAdapterPad.isNumber("")).assertFalse();
      expect(FormStackDbAdapterPad.isNumber(null)).assertFalse();
      expect(FormStackDbAdapterPad.isNumber(undefined)).assertFalse();
      expect(FormStackDbAdapterPad.isNumber("abc")).assertFalse();
      expect(FormStackDbAdapterPad.isNumber("123")).assertTrue();
    });

    it('FormStackDbAdapterPad_006', 0, () => {
      expect(FormStackDbAdapterPad.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbAdapterPad.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbAdapterPad.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbAdapterPad.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbAdapterPad.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbAdapterPad.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbAdapterPad_007', 0, () => {
      expect(FormStackDbAdapterPad.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbAdapterPad.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbAdapterPad.getDefaultId('') === '').assertTrue();
      expect(FormStackDbAdapterPad.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbAdapterPad.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbAdapterPad.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbAdapterPad_008', 0, () => {
      expect(FormStackDbAdapterPad.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbAdapterPad_009', 0, () => {
      expect(FormStackDbAdapterPad.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbAdapterPad.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbAdapterPad_010', 0, () => {
      expect(FormStackDbAdapterPad.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbAdapterPad.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbAdapterPad_011', 0, () => {
      expect(FormStackDbAdapterPad.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbAdapterPad.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbAdapterPad_012', 0, () => {
      expect(FormStackDbAdapterPad.checkArr([]) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(null) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbAdapterPad.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbAdapterPad.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbAdapterPad_013', 0, () => {
      expect(FormStackDbAdapterPad.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbAdapterPad.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbAdapterPad_014', 0, () => {
      expect(FormStackDbAdapterPad.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbAdapterPad.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbAdapterPad_015', 0, () => {
      expect(FormStackDbAdapterPad.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPad.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbAdapterPad_016', 0, () => {
      expect(FormStackDbAdapterPad.isEmpty(null)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(undefined)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty('')).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(0)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty([])).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(1, null)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(1, true)).assertTrue();
      expect(FormStackDbAdapterPad.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbAdapterPad_017', 0, () => {
      expect(FormStackDbAdapterPad.equals(null, 'a')).assertFalse();
      expect(FormStackDbAdapterPad.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbAdapterPad.equals('a', null)).assertFalse();
      expect(FormStackDbAdapterPad.equals('a', undefined)).assertFalse();
      expect(FormStackDbAdapterPad.equals('a', 1)).assertFalse();
      expect(FormStackDbAdapterPad.equals(1, 'a')).assertFalse();
      expect(FormStackDbAdapterPad.equals(1, [])).assertFalse();
      expect(FormStackDbAdapterPad.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbAdapterPad.equals([], m)).assertFalse();
      expect(FormStackDbAdapterPad.equals(m, [])).assertFalse();
      expect(FormStackDbAdapterPad.equals([1,2], [])).assertFalse();
      expect(FormStackDbAdapterPad.equals([], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPad.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPad.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPad.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbAdapterPad.equals(2, 2)).assertTrue();
    })
  });
}