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
import { FormStackDbManagerPc } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbManagerPc';

export function FormStackDbManagerPcTest() {
  describe('FormStackDbManagerPcTest', () => {
    it('FormStackDbManagerPc_001', 0, () => {
      expect(FormStackDbManagerPc.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbManagerPc.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbManagerPc_002', 0, () => {
      expect(FormStackDbManagerPc.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPc.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbManagerPc_003', 0, () => {
      expect(FormStackDbManagerPc.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbManagerPc.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbManagerPc_004', 0, () => {
      expect(FormStackDbManagerPc.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPc.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbManagerPc_005', 0, () => {
      expect(FormStackDbManagerPc.isNumber("")).assertFalse();
      expect(FormStackDbManagerPc.isNumber(null)).assertFalse();
      expect(FormStackDbManagerPc.isNumber(undefined)).assertFalse();
      expect(FormStackDbManagerPc.isNumber("abc")).assertFalse();
      expect(FormStackDbManagerPc.isNumber("123")).assertTrue();
    });

    it('FormStackDbManagerPc_006', 0, () => {
      expect(FormStackDbManagerPc.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbManagerPc.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbManagerPc.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbManagerPc.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbManagerPc.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbManagerPc.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbManagerPc_007', 0, () => {
      expect(FormStackDbManagerPc.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbManagerPc.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbManagerPc.getDefaultId('') === '').assertTrue();
      expect(FormStackDbManagerPc.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbManagerPc.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbManagerPc.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbManagerPc_008', 0, () => {
      expect(FormStackDbManagerPc.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbManagerPc_009', 0, () => {
      expect(FormStackDbManagerPc.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbManagerPc.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbManagerPc.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbManagerPc_010', 0, () => {
      expect(FormStackDbManagerPc.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbManagerPc.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbManagerPc_011', 0, () => {
      expect(FormStackDbManagerPc.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbManagerPc.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbManagerPc_012', 0, () => {
      expect(FormStackDbManagerPc.checkArr([]) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(null) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbManagerPc.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbManagerPc.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbManagerPc_013', 0, () => {
      expect(FormStackDbManagerPc.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbManagerPc.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbManagerPc_014', 0, () => {
      expect(FormStackDbManagerPc.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbManagerPc.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbManagerPc_015', 0, () => {
      expect(FormStackDbManagerPc.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPc.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbManagerPc_016', 0, () => {
      expect(FormStackDbManagerPc.isEmpty(null)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(undefined)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty('')).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(0)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty([])).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(1, null)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(1, true)).assertTrue();
      expect(FormStackDbManagerPc.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbManagerPc_017', 0, () => {
      expect(FormStackDbManagerPc.equals(null, 'a')).assertFalse();
      expect(FormStackDbManagerPc.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbManagerPc.equals('a', null)).assertFalse();
      expect(FormStackDbManagerPc.equals('a', undefined)).assertFalse();
      expect(FormStackDbManagerPc.equals('a', 1)).assertFalse();
      expect(FormStackDbManagerPc.equals(1, 'a')).assertFalse();
      expect(FormStackDbManagerPc.equals(1, [])).assertFalse();
      expect(FormStackDbManagerPc.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbManagerPc.equals([], m)).assertFalse();
      expect(FormStackDbManagerPc.equals(m, [])).assertFalse();
      expect(FormStackDbManagerPc.equals([1,2], [])).assertFalse();
      expect(FormStackDbManagerPc.equals([], [1, 2])).assertFalse();
      expect(FormStackDbManagerPc.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbManagerPc.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbManagerPc.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbManagerPc.equals(2, 2)).assertTrue();
    })
  });
}