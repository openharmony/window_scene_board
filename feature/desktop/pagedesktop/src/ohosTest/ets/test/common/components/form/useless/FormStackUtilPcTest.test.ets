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
import { FormStackUtilPc } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilPc';

export function FormStackUtilPcTest() {
  describe('FormStackUtilPcTest', () => {
    it('FormStackUtilPc_001', 0, () => {
      expect(FormStackUtilPc.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilPc.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilPc_002', 0, () => {
      expect(FormStackUtilPc.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilPc.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilPc_003', 0, () => {
      expect(FormStackUtilPc.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPc.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPc.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilPc.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilPc_004', 0, () => {
      expect(FormStackUtilPc.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilPc.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilPc_005', 0, () => {
      expect(FormStackUtilPc.isNumber("")).assertFalse();
      expect(FormStackUtilPc.isNumber(null)).assertFalse();
      expect(FormStackUtilPc.isNumber(undefined)).assertFalse();
      expect(FormStackUtilPc.isNumber("abc")).assertFalse();
      expect(FormStackUtilPc.isNumber("123")).assertTrue();
    });

    it('FormStackUtilPc_006', 0, () => {
      expect(FormStackUtilPc.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilPc.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilPc.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilPc.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilPc.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilPc.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilPc_007', 0, () => {
      expect(FormStackUtilPc.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilPc.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilPc.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilPc.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilPc.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilPc.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilPc_008', 0, () => {
      expect(FormStackUtilPc.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilPc.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilPc_009', 0, () => {
      expect(FormStackUtilPc.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilPc.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilPc.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilPc_010', 0, () => {
      expect(FormStackUtilPc.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilPc.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilPc_011', 0, () => {
      expect(FormStackUtilPc.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilPc.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilPc_012', 0, () => {
      expect(FormStackUtilPc.checkArr([]) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(null) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilPc.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilPc.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilPc_013', 0, () => {
      expect(FormStackUtilPc.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilPc.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilPc_014', 0, () => {
      expect(FormStackUtilPc.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilPc.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilPc_015', 0, () => {
      expect(FormStackUtilPc.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilPc.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilPc_016', 0, () => {
      expect(FormStackUtilPc.isEmpty(null)).assertTrue();
      expect(FormStackUtilPc.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilPc.isEmpty('')).assertTrue();
      expect(FormStackUtilPc.isEmpty(0)).assertTrue();
      expect(FormStackUtilPc.isEmpty([])).assertTrue();
      expect(FormStackUtilPc.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilPc.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilPc.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilPc.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilPc_017', 0, () => {
      expect(FormStackUtilPc.equals(null, 'a')).assertFalse();
      expect(FormStackUtilPc.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilPc.equals('a', null)).assertFalse();
      expect(FormStackUtilPc.equals('a', undefined)).assertFalse();
      expect(FormStackUtilPc.equals('a', 1)).assertFalse();
      expect(FormStackUtilPc.equals(1, 'a')).assertFalse();
      expect(FormStackUtilPc.equals(1, [])).assertFalse();
      expect(FormStackUtilPc.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilPc.equals([], m)).assertFalse();
      expect(FormStackUtilPc.equals(m, [])).assertFalse();
      expect(FormStackUtilPc.equals([1,2], [])).assertFalse();
      expect(FormStackUtilPc.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilPc.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilPc.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilPc.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilPc.equals(2, 2)).assertTrue();
    })
  });
}