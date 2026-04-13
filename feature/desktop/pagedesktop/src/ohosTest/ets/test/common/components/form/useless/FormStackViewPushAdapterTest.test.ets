/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { FormStackViewPushAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPushAdapter';

export function FormStackViewPushAdapterTest() {
  describe('FormStackViewPushAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPushAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPushAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPushAdapter_002', 0, () => {
      expect(FormStackViewPushAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPushAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPushAdapter_003', 0, () => {
      expect(FormStackViewPushAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPushAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPushAdapter_004', 0, () => {
      expect(FormStackViewPushAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPushAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPushAdapter_005', 0, () => {
      expect(FormStackViewPushAdapter.isNumber("")).assertFalse();
      expect(FormStackViewPushAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewPushAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewPushAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewPushAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewPushAdapter_006', 0, () => {
      expect(FormStackViewPushAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPushAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPushAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPushAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPushAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPushAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPushAdapter_007', 0, () => {
      expect(FormStackViewPushAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPushAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPushAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPushAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPushAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPushAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPushAdapter_008', 0, () => {
      expect(FormStackViewPushAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPushAdapter_009', 0, () => {
      expect(FormStackViewPushAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPushAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPushAdapter_010', 0, () => {
      expect(FormStackViewPushAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPushAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPushAdapter_011', 0, () => {
      expect(FormStackViewPushAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPushAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPushAdapter_012', 0, () => {
      expect(FormStackViewPushAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPushAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPushAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPushAdapter_013', 0, () => {
      expect(FormStackViewPushAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPushAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPushAdapter_014', 0, () => {
      expect(FormStackViewPushAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPushAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPushAdapter_015', 0, () => {
      expect(FormStackViewPushAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPushAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPushAdapter_016', 0, () => {
      expect(FormStackViewPushAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPushAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPushAdapter_017', 0, () => {
      expect(FormStackViewPushAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewPushAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPushAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewPushAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewPushAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewPushAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewPushAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewPushAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPushAdapter.equals([], m)).assertFalse();
      expect(FormStackViewPushAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewPushAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewPushAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPushAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPushAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPushAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPushAdapter.equals(2, 2)).assertTrue();
    })
  });
}